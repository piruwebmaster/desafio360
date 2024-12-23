import z  from 'zod'

const base = {
    quantity: z.number().min(1),
    tax_rate: z.number().min(1),
    sell_price: z.number().min(1)
    
};


const createDtoSchema = z.object({
    ...base,
    product_id: z.number().min(1),
    order_id: z.number().min(1),
})
   
 
const createSchema = z.object({
    ...base,
    product_id: z.number().min(1),
    order_id: z.number().min(1),    
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