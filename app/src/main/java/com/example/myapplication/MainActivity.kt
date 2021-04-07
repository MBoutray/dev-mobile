package com.example.myapplication

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.TextUtils.isDigitsOnly
import android.util.Log
import android.view.ContextThemeWrapper
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView

class MainActivity : AppCompatActivity() {

    companion object {
        private val INPUT_BUTTONS = listOf(
                listOf("C", "CE", "", "/"),
                listOf("1", "2", "3", "*"),
                listOf("4", "5", "6", "-"),
                listOf("7", "8", "9", "+"),
                listOf(".", "0", "", "="),
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        addCells(findViewById(R.id.calculator_input_container_line1), 0)
        addCells(findViewById(R.id.calculator_input_container_line2), 1)
        addCells(findViewById(R.id.calculator_input_container_line3), 2)
        addCells(findViewById(R.id.calculator_input_container_line4), 3)
        addCells(findViewById(R.id.calculator_input_container_line5), 4)
    }

    private fun addCells(linearLayout: LinearLayout, position: Int) {
        for (x in INPUT_BUTTONS[position].indices) {
            linearLayout.addView(
                    TextView(
                            ContextThemeWrapper(this, R.style.CalculatorInputButton)
                    ).apply {
                        text = INPUT_BUTTONS[position][x]
                        setOnClickListener { onCellClicked(this.text.toString()) }
                    },
                    LinearLayout.LayoutParams(
                            0,
                            ViewGroup.LayoutParams.MATCH_PARENT,
                            1f
                    )
            )
        }
    }

    private var input: Float? = null
    private var rawInput: String = ""
    private var previousInput: Float? = null
    private var symbol: String? = null

    private fun onCellClicked(value: String) {
        when {
            value.isNum() -> {
                rawInput += value
                input = rawInput.toFloat()
                updateDisplayContainer(input!!)
            }
            value == "=" -> onEqualsClicked()
            value == "." -> {
                if (rawInput.contains('.')) return

                rawInput += value
                input = rawInput.toFloat()
                updateDisplayContainer(input!!)
            }
            value == "C" -> {
                if (rawInput.length <= 0) return

                rawInput = rawInput.substring(0, rawInput.length - 1)
                if (rawInput.length == 0) {
                    input = null
                } else {
                    input = rawInput.toFloat()
                }
                updateDisplayContainer(input!!)
            }
            value == "CE" -> {
                rawInput = ""
                input = null
                updateDisplayContainer(input!!)
            }
            listOf("/", "*", "-", "+").contains(value) -> onSymbolClicked(value)
        }
    }

//    private fun onDotClicked() {
//        input
//    }

    private fun onSymbolClicked(symbol: String) {
        this.symbol = symbol
        previousInput = input
        input = null
        rawInput = ""
    }

    private fun onEqualsClicked() {
        if (input == null || previousInput == null || symbol == null) {
            return
        } else if (symbol == "/" && input == 0f) {
            updateDisplayContainer("ERROR")
            resetVariables()
            return
        }

        updateDisplayContainer(when (symbol) {
            "+" -> previousInput!! + input!!
            "-" -> previousInput!! - input!!
            "*" -> previousInput!! * input!!
            "/" -> previousInput!! / input!!
            else -> "ERROR"
        })

        resetVariables()
    }

    private fun updateDisplayContainer(value: Any) {
        findViewById<TextView>(R.id.calculator_display_container).text = value.toString()
    }

    private fun resetVariables() {
        input = null
        rawInput = ""
        previousInput = null
        symbol = null
    }
}

fun String.isNum(): Boolean {
    return length == 1 && isDigitsOnly(this)
}