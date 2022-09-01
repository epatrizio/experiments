let vqueue_capacity = 4;;
let vproducer_production = 10;;
let vconsumer_need = 5;;

let vegetables_queue = Queue.create ();;

let rec vproducer arg =
  let (c_send, vegetable_name, cpt_prod) = arg in
    Event.sync (Event.send c_send (vegetable_name ^ string_of_int (cpt_prod)));
    if cpt_prod < vproducer_production then
      vproducer (c_send, vegetable_name, (cpt_prod+1));
;;

let rec vconsumer arg =
  let (c_req, consumer_name, cpt_cons) = arg in
  let c_ret = Event.new_channel () in
    Event.sync (Event.send c_req c_ret);
    let vegetable = Event.sync (Event.receive c_ret) in
      print_string (consumer_name ^ " >> " ^ vegetable);
      print_newline ();
      if cpt_cons < vconsumer_need then
        vconsumer (c_req, consumer_name, (cpt_cons+1))
;;

let rec vqueue arg =
  let (c_prod_receive, c_cons_req) = arg in
  let size = Queue.length vegetables_queue in (
    match size with
    | s when s == 0 ->
      let vege = Event.sync (Event.receive c_prod_receive) in
        Queue.push vege vegetables_queue
    | s when s == vqueue_capacity ->
      let c_out = Event.sync (Event.receive c_cons_req) in
        Event.sync (Event.send c_out (Queue.pop vegetables_queue))
    | _ ->
        Event.sync (
          Event.choose [
            Event.wrap (Event.receive c_prod_receive) (fun vege -> Queue.push vege vegetables_queue);
            Event.wrap (Event.receive c_cons_req) (fun c_out -> Event.sync (Event.send c_out (Queue.pop vegetables_queue)))
          ]
        )
    );
    vqueue (c_prod_receive, c_cons_req)
;;

let () =
  let c_prod = Event.new_channel () in
  let c_cons = Event.new_channel () in
  let _ = Thread.create vqueue (c_prod, c_cons)
  and _ = Thread.create vproducer (c_prod, "apple", 1)
  and _ = Thread.create vproducer (c_prod, "pear", 1)
  and _ = Thread.create vproducer (c_prod, "banana", 1)
  and c1 = Thread.create vconsumer (c_cons, "C1", 1)
  and c2 = Thread.create vconsumer (c_cons, "C2", 1)
  in
    Thread.join c1;
    Thread.join c2
;;
