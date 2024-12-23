import z  from 'zod'

//const states = [ 'AWAITING_PAYMENT', 'CANCELLED', 'COMPLETED', 'DELIVERED', 'FAILED', 'ON_HOLD', 'OUT_FOR_DELIVERY', 'PAYMENT_CONFIRMED', 'PENDING', 'PLACED', 'PROCESSING', 'REFUNDED', 'RETURNED', 'SHIPPED'] as const
//const orderState = z.enum(states)

const base = {
    estimated_delivery_date: z.coerce.date(),
    delivery_date: z.coerce.date().nullable().default(null),
};


const createDtoSchema = z.object({
    ...base,
    client_id: z.number().min(1)
})
   
 
const createSchema = z.object({
    ...base,
    client_id: z.number().min(1),
    order_state_id: z.enum(["PLACED"])
})
    

const updateDtoSchema = z.object(base)
const updateSchema =
    z.intersection(
        updateDtoSchema, 
        z.object({
            id: z.number().min(1),   
        })
)


export { createSchema, updateDtoSchema, updateSchema, createDtoSchema }