let h = 20
let w = 30

let life_screen = Array.make_matrix h w false

let life_screen_init () : unit = 
  let rand_val (bound : int) : bool =
    let r = Random.int bound in r = 0
  in
  for i = 0 to (h-1) do
    for j = 0 to (w-1) do
      life_screen.(i).(j) <- rand_val 5
    done
  done

let is_alive (x : int) (y : int) : bool = life_screen.(x).(y)

let life_screen_print () : unit =
  let cell_print (c : bool) =
    print_string (if c then "| X " else "|   ")
  in
  let line_print (l : bool array) =
    Array.iter cell_print l;
    print_newline ()
  in
  print_string "\027[2J";
  Array.iter line_print life_screen

let count_alive (x : int) (y : int) : int =
  let nb_alive = ref 0 in
  let cell_process (x : int) (y : int) : unit =
    match x, y with
    | x, y when x < 0 || x >= h || y < 0 || y >= w -> ()
    | _, _ -> if is_alive x y then incr nb_alive else ()
  in
  cell_process (x-1) (y-1);
  cell_process (x-1) (y);
  cell_process (x-1) (y+1);
  cell_process (x) (y-1);
  cell_process (x) (y+1);
  cell_process (x+1) (y-1);
  cell_process (x+1) (y);
  cell_process (x+1) (y+1);
  !nb_alive

let life_screen_step () : unit =
  let matrix_count_alive = 
    Array.init h (fun x -> Array.init w (fun y -> count_alive x y))
  in
  let cell_step (x : int) (y : int) : unit =
    let nb_alive = matrix_count_alive.(x).(y) in
    life_screen.(x).(y) <- (* Game rules *)
      if is_alive x y then nb_alive = 2 || nb_alive = 3 (* first rule *)
      else nb_alive = 3 (* second rule *)
  in
  Array.iteri (fun x ax -> Array.iteri (fun y _ -> cell_step x y) ax) life_screen

let life () : unit =
  life_screen_init ();
  let rec loop i =
    if i = 100 then ()
    else (
      life_screen_print ();
      Unix.sleepf 0.3;
      life_screen_step ();
      loop (i+1)
    )
  in
    loop 0

let _ = life ()
