// Some functional programming basic patterns in TypeScript

function add0(a: number, b: number) {
  return a + b;
}

const add10 = (a: number, b: number): number => {return a + b};
const add11 = (a: number, b: number): number => a + b;

// Currying: Partial application, function construction
const add2 = (a: number) => (b: number): number => a + b;
// add2 40 2 - incorrect, need parenthesis
console.log(add2(40)(2))    // 42 
const add2_40 = add2(40);
console.log(add2_40(2));    // 42

// Closure
const counter = (x: number) : () => number => {
  let i = x;
  return () => {
    i = i + 1;
    return i;
  };
}

const counter1 = counter(10);
const counter2 = counter(20);

console.log(counter1());  // 11
console.log(counter1());  // 12
console.log(counter1());  // 13
console.log(counter1());  // 14

console.log(counter2());  // 21
console.log(counter2());  // 22
console.log(counter2());  // 23

// Array map wrapper in a functional style: signature (T -> U) -> T[] -> U[]
const map = <T, U>(fmap: (x: T) => U) => (arr: T[]) : U[] => {
  return arr.map(fmap)
}
console.log(
  map ((x:number) : number => x*x) ([1,2,3])
  // map ((x: string) => x) ([1,2,3]) -- typing error
);

// Classic "Option" type (~"Result" type) Ex. for clean function return types
type Some<T> = {
  _tag: "some",
  value: T
}

type None = {
  _tag: "none",
  value: any
}

type Option<T> =
  | Some<T>
  | None

// Some type constructor
const some = <T>(value: T): Some<T> => ({
  _tag: "some",
  value,
});

// None type constructor
const none = () : None => ({
  _tag: "none",
  value: null
});

const div = (a: number) => (b: number): number => a / b;
console.log(div(42)(0));  // Infinity

const div_opt = (a: number) => (b: number): Option<number> => {
  if (b != 0)
    return some(a/b)
  else
    return none()
};

console.log(div_opt(42)(2));
console.log(div_opt(42)(0));

// Basic approach
let d_1 = div_opt(168)(2);
if (d_1._tag === "some") {
  let d_2 = div_opt(d_1.value)(2);
  if (d_2._tag === "some")
    console.log(d_2.value)
  else
    console.log("div by zero!");
}
else
  console.log("div by zero!");

//  -- Monad approach for a clean chaining
// Basic monad element generation
const ret = <T>(value: T): Option<T> => some(value)
// Binding: The major feature! (Chaining, linking, like JS Promise)
const bind = <T, U>(v_opt: Option<T>) => (f: (v: T) => Option<U>) : Option<U> => {
  if (v_opt._tag === "some")
    return f(v_opt.value)
  else
    return none()
}

d_1 = div_opt(80)(2);
let d_2 = bind(d_1)((x:number) : Option<number> => ret(x+2));
console.log(d_2)
// { _tag: "some", value: 42 }
// only the last chain element needs to be processed
// Note that there is no pattern matching in TS.
// Use "if else" or "switch case" structures (less powerful)

// Data structure example import

import {
  Stack,
  stack_isempty,
  stack_size,
  stack_push,
  stack_pop
} from "./func_prog_ds.ts";


let stack: Stack<string> = [];      // Stack impl with an array: could be hidden
console.log(stack_isempty(stack));  // true

stack_push("str1")(stack);
stack_push("str2")(stack);
// stack_push(1)(stack);            // typing error
stack_push("str3")(stack);
console.log(stack_isempty(stack));  // false
console.log(stack_size(stack));     // 3
console.log(stack_pop(stack));      // str3
console.log(stack_size(stack));     // 2
