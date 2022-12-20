open Mirage_crypto_ec

open Crypto
open Utils

let client client_fun  =
  let port = 1400 in
  let localhost = get_localhost () in
  let sockaddr = Unix.ADDR_INET(localhost, port) in
  let ic, oc = Unix.open_connection sockaddr in
    client_fun ic oc;
    Unix.shutdown_connection ic

let client_login ic oc =
  try
    while true do  
      print_string  "Login: ";
      flush stdout;
      let log = Cstruct.of_string (input_line stdin) in
      let res = Ed25519.priv_of_cstruct (Cstruct.of_bytes keys.private_key) in
      match res with
        | Ok priv -> 
            output_string oc ((Cstruct.to_string (sign_msg priv log))^"\n");
            flush oc ;
            let r = input_line ic in
              Printf.printf "Response : %s\n\n" r;
              if r = "END" then ( Unix.shutdown_connection ic ; raise Exit)
        | Error _ -> output_string oc "error\n"; flush oc
    done
  with 
      Exit -> exit 0
    | exn -> Unix.shutdown_connection ic ; raise exn

let () =
  print_endline "Client start ...";
  client client_login
