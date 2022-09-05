#define VQUEUE_CAPACITY 4
#define VPRODUCER_PRODUCTION 10
#define VCONSUMER_NEED 5

proctype vproducer(int vp_id; chan c_send) {
    int current_production = 0
    begin:
        if
            :: current_production < VPRODUCER_PRODUCTION ->
                current_production = current_production+1
                c_send!vp_id
                goto begin
        fi
}

proctype vconsumer(int vc_id; chan c_req; chan c_end) {
    int current_need = 0
    int vege_get
    chan req = [0] of {int}
    begin:
        if
            :: current_need < VCONSUMER_NEED ->
                current_need = current_need+1
                c_req!req
                req?vege_get
                printf("CONS :: vc_id:%d >> vege_get:%d\n", vc_id, vege_get)
                goto begin
            :: current_need >= VCONSUMER_NEED -> goto end
        fi
    end:
        c_end!vc_id
}

proctype vqueue(chan c_prod_receive; chan c_cons_req; chan c_obs) {
    int size = 0
    int vp_id
    chan c_out = [0] of {int}
    loop:
        do
            :: size == 0 -> c_prod_receive?vp_id; size = size+1; c_obs!vp_id,size
            :: size == VQUEUE_CAPACITY -> c_cons_req?c_out; c_out!0; size = size-1; c_obs!0,size
            :: size > 0 && size < VQUEUE_CAPACITY ->
                if
                    :: c_prod_receive?vp_id -> size = size+1; c_obs!vp_id,size
                    :: c_cons_req?c_out -> c_out!0; size = size-1; c_obs!0,size
                fi
        od
}

proctype observer(chan c_obs) {
    int id, s
    do
        :: c_obs?(id,s) -> printf("OBS :: vp_id:%d - vq_size:%d\n",id,s)
    od
}

init {
    int n = 0

    chan c_prod = [0] of {int}
    chan c_cons = [0] of {int}
    chan c_end = [0] of {int}
    chan c_obs = [0] of {int,int}

    run vproducer(1, c_prod)
    run vproducer(2, c_prod)
    run vproducer(3, c_prod)

    run vconsumer(1, c_cons, c_end)
    run vconsumer(2, c_cons, c_end)

    run vqueue(c_prod, c_cons, c_obs)

    run observer(c_obs)

    c_end?n -> printf("consumer %d has finished!", n)
    c_end?n -> printf("consumer %d has finished!", n)

    assert(n == 1 || n == 2)
}
