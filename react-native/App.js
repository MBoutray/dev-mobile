import React, { Component } from 'react';
import { View, Text, AppRegistry } from 'react-native';
import Style from './src/Style';
import InputButton from './src/InputButton';

const inputButtons = [
  ['C', 'CE', "", ""],
  [1, 2, 3, '/'],
  [4, 5, 6, '*'],
  [7, 8, 9, '-'],
  [0, '.', '=', '+'],
];

class ReactCalculator extends Component {
  constructor(props) {
    super(props);

    this.state = {
      inputValue: 0,
      previousInputValue: 0,
      selectedSymbol: null,
      displayValue: 0,
      isFloating: false
    }
  }

  render() {
    return (
      <View style={Style.rootContainer}>
        <View style={Style.displayContainer}>
          <Text style={Style.displayText}>{this.state.displayValue}</Text>
        </View>
        <View style={Style.inputContainer}>
          {this._renderInputButtons()}
        </View>
      </View>
    );
  }

  _renderInputButtons() {
    let views = [];

    for (var r = 0; r < inputButtons.length; r++) {
      let row = inputButtons[r];

      let inputRow = [];
      for (var i = 0; i < row.length; i++) {
        let input = row[i];

        inputRow.push(
          <InputButton 
            value={input} 
            key={r + '-' + i}
            onPress={this._onInputButtonPressed.bind(this, input)}/>
        );
      }

      views.push(
        <View style={Style.inputRow} key={'row-' + r}>
          {inputRow}
        </View>
      );
    }

    return views;
  }

  _onInputButtonPressed(input) {
    switch(typeof input) {
      case 'number':
        return this._handleNumberInput(input);
      case 'string':
        return this._handleStringInput(input);
    }
  }

  _handleNumberInput(num) {
    let splitInputValue = this.state.inputValue.toString().split('.');
    let floatingDigitCount = splitInputValue.length > 1 ? splitInputValue[1].length : 0;

    let inputValue = this.state.isFloating ? parseFloat((this.state.inputValue + (num * Math.pow(0.1, floatingDigitCount + 1))).toFixed(floatingDigitCount + 1)) : (this.state.inputValue * 10) + num;

    this.setState({
      inputValue,
      displayValue: inputValue
    })
  }

  _handleStringInput(str) {
    switch(str) {
      case '/':
      case '*':
      case '+':
      case '-':
        this.setState({
          inputValue: 0,
          previousInputValue: this.state.inputValue,
          selectedSymbol: str,
          displayValue: str,
          isFloating: false
        });
        break;
      case '.':
        this.setState({
          isFloating: true
        });
        break;
      case 'C':
        if(this.state.isFloating) {
          let floatingDigitsCount = this.state.inputValue.toString().split('.')[1].length;
          let inputValue = this.state.inputValue.toString();
          inputValue = parseFloat(inputValue.substr(0, inputValue.length - 1))

          this.setState({
            inputValue,
            displayValue: inputValue
          });

          if(floatingDigitsCount == 1) {
            this.setState({
              isFloating: false
            });
          }
        } else {
          this.setState({
            inputValue: Math.floor(this.state.inputValue / 10),
            displayValue: Math.floor(this.state.inputValue / 10)
          });
        }
        break;
      case 'CE':
        this.setState({
          inputValue: 0,
          previousInputValue: 0,
          selectedSymbol: null,
          displayValue: 0,
          isFloating: false
        });
        break;
      case '=':
        let symbol = this.state.selectedSymbol,
            inputValue = this.state.inputValue,
            previousInputValue = this.state.previousInputValue;

        if(!symbol) {
          return;
        }
        if(symbol == '/' && inputValue == 0) {
          this.setState({
            inputValue: 0,
            previousInputValue: 0,
            selectedSymbol: null,
            displayValue: "ERROR",
            isFloating: false
          });
          return;
        }

        this.setState({
          inputValue: 0,
          previousInputValue: 0,
          selectedSymbol: null,
          displayValue: eval(previousInputValue + symbol + inputValue),
          isFloating: false
        });
        
        break;
    }
  }
}

export default ReactCalculator;
