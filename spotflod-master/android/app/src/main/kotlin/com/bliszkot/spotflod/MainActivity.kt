package com.bliszkot.spotflod

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.tensorflow.lite.support.common.ops.NormalizeOp
import org.tensorflow.lite.support.image.ImageProcessor
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.image.ops.ResizeOp
import org.tensorflow.lite.task.core.BaseOptions
import org.tensorflow.lite.task.vision.classifier.Classifications
import org.tensorflow.lite.task.vision.classifier.ImageClassifier
import java.io.File
import java.io.FileInputStream
import java.io.InputStream
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel
import kotlin.math.exp
import kotlin.math.round

class MainActivity : FlutterActivity() {
    private val channelName = "classifier"
    private var imageClassifier: ImageClassifier? = null
    private val numberOfThreads = 1
    private val maxOutput = 8
    private val modelName = "model.tflite"
    private val threshold = 0.5F
    private val mean = 0.0F
    private val stdDev = 1.0F
    private val imageSize = 180

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "classifyImage" -> {
                        imageClassification(call, result)
                    }
                    "cacheDir" -> {
                        result.success(cacheDir.path)
                    }
                    "filesDir" -> {
                        result.success(filesDir.path)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun imageClassification(call: MethodCall, result: MethodChannel.Result) {
        setupImageClassifier()

        val path = call.argument<String>("path")
        val classification = classify(path!!)[0].categories
        val score = classification.map { it.score }

        // Score to confidence. Python numpy : np.exp(score) / np.sum(np.exp(score))
        val scoresExp = score.map { exp(it) }
        val scoreExpSum = scoresExp.sum()
        val confidence = score.map { exp(it) / scoreExpSum }
        val confidencePerc: List<Float> = confidence.map { 100 * it }

        val resultList: List<Map<String, Any>> = classification.map {
            mapOf<String, Any>(
                "label" to it.label,
                "index" to it.index,
                // Up to 3 decimal places
                "confidence" to round(confidencePerc[score.indexOf(it.score)] * 1000 / 1000)
            )
        }

        result.success(resultList).run {
            imageClassifier = null
        }
    }

    private fun setupImageClassifier() {
        val optionsBuilder =
            ImageClassifier.ImageClassifierOptions.builder().setScoreThreshold(threshold)
                .setMaxResults(maxOutput)

        val baseOptionsBuilder = BaseOptions.builder().setNumThreads(numberOfThreads).useNnapi()

        optionsBuilder.setBaseOptions(baseOptionsBuilder.build())

        val file = FileInputStream("$filesDir/model/model.tflite").channel
        val tfliteModelBuffer: MappedByteBuffer = file.map(FileChannel.MapMode.READ_ONLY, 0, file.size())
        imageClassifier = ImageClassifier.createFromBufferAndOptions(tfliteModelBuffer, optionsBuilder.build())
        file.close()
    }

    private fun classify(path: String): MutableList<Classifications> {
        val inputStream: InputStream = File(path).inputStream()
        val image: Bitmap = BitmapFactory.decodeStream(inputStream)

        if (imageClassifier == null) {
            setupImageClassifier()
        }

        val imageProcessor = ImageProcessor.Builder()
            .add(ResizeOp(imageSize, imageSize, ResizeOp.ResizeMethod.BILINEAR))
            .add(NormalizeOp(mean, stdDev))
            .build()

        // Preprocess the image and convert it into a TensorImage for classification.
        val tensorImage = imageProcessor.process(TensorImage.fromBitmap(image))
        inputStream.close()
        // Classify
        return imageClassifier!!.classify(tensorImage)
    }
}
