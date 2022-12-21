(* public/private key generation by Crypto.generate_keys function (crypto.ml) *)
(* private key is used by client to sign messages - public key is used by server to check received message validity *)
(* of course, usually, keys are invisible!, and private key is send to client *)

let (priv, _) = Eqaf.bytes_of_hex "e088e9e9070f6fef047267d2ab800d92205a344212d1db228adf7013ebbe97e4"
let (pub, _) = Eqaf.bytes_of_hex "723995cb9d88eb0cb59515ca50a3687c94d809056120e58c46ade30135d68bd9"

type crypto_keys = {
  private_key : bytes;
  public_key : bytes
}

let keys = {
  private_key = priv;
  public_key = pub
}

(* Success authentication login = u_log *)
let user_login = Cstruct.of_string "u_log"

let get_localhost () =
  (Unix.gethostbyname(Unix.gethostname())).Unix.h_addr_list.(0)
