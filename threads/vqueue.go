package main

import "fmt"
import "strconv"

const VQUEUE_CAPACITY int = 4
const VPRODUCER_PRODUCTION int = 10
const VCONSUMER_NEED int = 5

func vproducer(c_send chan string, vegetable_name string) {
  for i := 1; i <= VPRODUCER_PRODUCTION; i++ {
    c_send <-vegetable_name + strconv.Itoa(i)
  }
}

func vconsumer(c_req chan (chan string), consumer_name string, c_end chan int) {
  for i := 1; i <= VCONSUMER_NEED; i++ {
    c_ret := make(chan string)
    c_req <-c_ret
    vegetable := <-c_ret
    fmt.Println(consumer_name + " >> " + vegetable)
  }
  c_end <-0
}

func vqueue(c_prod_receive chan string, c_cons_req chan (chan string)) {
  vegetables_queue := make([]string, 0)
  for {
    size := len(vegetables_queue)
    switch {
      case size == 0:
        vege := <-c_prod_receive
        vegetables_queue = append(vegetables_queue, vege)
      case size == VQUEUE_CAPACITY:
        c_out := <-c_cons_req
        vege := vegetables_queue[0]
        c_out <-vege
        vegetables_queue = vegetables_queue[1:]
      default:
        select {
          case vege := <-c_prod_receive :
            vegetables_queue = append(vegetables_queue, vege)
          case c_out := <-c_cons_req :
            vege := vegetables_queue[0]
            c_out <-vege
            vegetables_queue = vegetables_queue[1:]
        }
    }
  }
}

func main() {
  c_prod := make(chan string)
  c_cons := make(chan (chan string))
  c_end := make(chan int)

  go func(){ vproducer(c_prod, "apple") }()
  go func(){ vproducer(c_prod, "pear") }()
  go func(){ vproducer(c_prod, "banana") }()

  // we only wait the end of consumers threads (We consider that the production is higher than the needs)
  // c_end channel is used for synchronization
  go func(){ vconsumer(c_cons, "C1", c_end) }()
  go func(){ vconsumer(c_cons, "C2", c_end) }()

  go func(){ vqueue(c_prod, c_cons) }()

  <-c_end
  <-c_end
}