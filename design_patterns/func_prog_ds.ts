// Data structure example in TypeScript functional programming style

export type Stack<T> = T[]

// export const stack_create = <T>() : void => {
//    how to hide type initialization and implementation?
//    TODO
// }

export const stack_isempty = <T>(stack: Stack<T>) : boolean => {
  return stack.length === 0;
}

export const stack_size = <T>(stack: Stack<T>) : number => {
  return stack.length;
}

export const stack_push = <T>(elt : T) => (stack: Stack<T>) : void => {
  stack.push(elt);
}

// TODO: use type Option for return type
export const stack_pop = <T>(stack: Stack<T>) : T | undefined => {
  return stack.pop();  
}
