let client arg =
  let (c_req, name) = arg in
  let c_ret = Event.new_channel () in
  Event.sync (Event.send c_req (name, c_ret));
  let str_hello = Event.sync (Event.receive c_ret) in
    print_string str_hello;
    print_newline ()
;;

let rec server c_req =
  let (str_world, c_ret) = Event.sync (Event.receive c_req) in
    Event.sync (Event.send c_ret ("Hello, " ^ str_world ^ "!"));
    server c_req
;;

let () =
  let c_req = Event.new_channel () in
    let _ = Thread.create server c_req
    and c1 = Thread.create client (c_req,"world_1")
    and c2 = Thread.create client (c_req,"world_2")
    and c3 = Thread.create client (c_req,"world_3")
    and c4 = Thread.create client (c_req,"world_4")
    in
      Thread.join c1;
      Thread.join c2;
      Thread.join c3;
      Thread.join c4
