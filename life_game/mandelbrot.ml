open Graphics

let max_iteration = 1000

(* referential *)
let x_min = ref 0.
let x_max = ref 0.
let y_min = ref 0.
let y_max = ref 0.

(* window size *)
let w = 500
let h = 500

let diverge (mandelbrot : bool) (x : float) (y : float) : int =
  let cx = if mandelbrot then x *. (!x_max -. !x_min) /. (float_of_int w) +. !x_min else 0.285 in
  let cy = if mandelbrot then y *. (!y_min -. !y_max) /. (float_of_int h) +. !y_max else 0.01 in
  let rec diverge_step (xn : float) (yn : float) (it : int) : int =
    match it, xn*.xn +. yn*.yn with
    | i, _ when i >= max_iteration -> it
    | _, n when n >= 4. -> it
    | _, _ ->
      let xn1 = xn *. xn -. yn *. yn +. cx in
      let yn1 = 2.*.xn*.yn +. cy in
        diverge_step xn1 yn1 (it+1)
  in
  if mandelbrot then diverge_step 0. 0. 0
  else (
    let xn = x *. (!x_max -. !x_min) /. (float_of_int w) +. !x_min in
    let yn = y *. (!y_min -. !y_max) /. (float_of_int h) +. !y_max in
    diverge_step xn yn 0
  )

(* mandelbrot true = Mandelbrot set *)
(* mandelbrot false = Julia set *)
let fractal (mandelbrot : bool) : unit =
  if mandelbrot then (
    x_min := -2.;
    x_max := 0.5;
    y_min := -1.25;
    y_max := 1.25
  ) else (
    x_min := -1.25;
    x_max := 1.25;
    y_min := -1.25;
    y_max := 1.25;
  );
  open_graph " 500x500";
  clear_graph ();
  for x = 0 to w do
    for y = 0 to h do
      let k = diverge mandelbrot (float_of_int x) (float_of_int y) in
      set_color (rgb ((3 * k) mod 256) ((1 * k) mod 256) (10 * k) mod 256);
      plot x y
    done
  done;
  let _ = wait_next_event [Key_pressed] in ()

let _ =
  fractal true (* mandelbrot set *)
  (*fractal false*) (* mandelbrot set *)
