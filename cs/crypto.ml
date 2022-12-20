open Mirage_crypto_ec

exception CryptoError of string

let () = Mirage_crypto_rng_unix.initialize ()

let generate_keys () : Ed25519.priv * Ed25519.pub =
  Ed25519.generate ()

let private_key_len (key : Ed25519.priv) : int =
  Cstruct.length (Ed25519.priv_to_cstruct key)

let public_key_len (key : Ed25519.pub) : int =
  Cstruct.length (Ed25519.pub_to_cstruct key)

let sign_msg (private_key : Ed25519.priv) msg =
  Ed25519.sign ~key:private_key msg

let verify_msg (public_key : Ed25519.pub) sign msg : bool =
  Ed25519.verify ~key:public_key sign ~msg:msg

let get_public_bkey (bkey : bytes) : Ed25519.pub option =
  let res = Ed25519.pub_of_cstruct (Cstruct.of_bytes bkey) in
    match res with
    | Ok pub -> Some pub
    | Error _ -> None

let get_private_bkey (bkey : bytes) : Ed25519.priv option =
  let res = Ed25519.priv_of_cstruct (Cstruct.of_bytes bkey) in
    match res with
    | Ok priv -> Some priv
    | Error _ -> None
