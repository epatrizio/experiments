package main

import "fmt"
import "sync"

type req struct {
  world string
  c_ret chan string
}

var wg sync.WaitGroup

func client(c_req chan req, name string) {
  defer wg.Done()
  c_ret := make(chan string)
  c_req <-req {world: name, c_ret: c_ret}
  str_hello := <-c_ret
  fmt.Println(str_hello)
  close(c_ret)
}

func server(c_req chan req) {
  for {
    in_request := <-c_req
    go func(r req) {
      str_world := "Hello, " + r.world + "!"
      r.c_ret <-str_world
    }(in_request)
  }
}

func main() {
  c_req := make(chan req)

  wg.Add(4)
  
  go func(){ client(c_req, "world_1") }()
  go func(){ client(c_req, "world_2") }()
  go func(){ client(c_req, "world_3") }()
  go func(){ client(c_req, "world_4") }()

  go func(){ server(c_req) }()

  wg.Wait()
  close(c_req)
}
