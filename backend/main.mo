import Array "mo:base/Array";
import Func "mo:base/Func";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";

import Float "mo:base/Float";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Char "mo:base/Char";
import Debug "mo:base/Debug";

actor Calculator {
    // Function to perform basic arithmetic operations
    private func operate(op: Text, x: Float, y: Float) : Float {
        switch (op) {
            case "+" { x + y };
            case "-" { x - y };
            case "*" { x * y };
            case "/" { 
                if (y == 0) {
                    Debug.trap("Division by zero");
                };
                x / y 
            };
            case _ { Debug.trap("Invalid operator") };
        };
    };

    // Function to parse a string into a float
    private func parseFloat(s: Text) : Float {
        var result: Float = 0;
        var decimalPlace: Float = 10;
        var isNegative = false;
        var seenDecimal = false;

        for (c in s.chars()) {
            if (c == '-') {
                isNegative := true;
            } else if (c == '.') {
                seenDecimal := true;
            } else {
                let digit = Char.toNat32(c) - 48;
                if (digit >= 0 and digit <= 9) {
                    if (seenDecimal) {
                        result += Float.fromInt(Nat32.toNat(digit)) / decimalPlace;
                        decimalPlace *= 10;
                    } else {
                        result := result * 10 + Float.fromInt(Nat32.toNat(digit));
                    };
                };
            };
        };

        if (isNegative) {
            -result;
        } else {
            result;
        };
    };

    // Public function to calculate the result of an expression
    public func calculate(expression: Text) : async Text {
        var numbers = Iter.toArray(Text.split(expression, #text(" ")));
        if (numbers.size() != 3) {
            return "Invalid expression";
        };

        let x = parseFloat(numbers[0]);
        let op = numbers[1];
        let y = parseFloat(numbers[2]);

        let result = operate(op, x, y);
        Float.toText(result);
    };
}
