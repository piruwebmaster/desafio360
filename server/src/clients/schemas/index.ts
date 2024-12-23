import z from 'zod'

const base = {
    email: z.string().min(2).max(256).refine(e=>e.includes('@'), "invalid email address"),
    phone_number: z.string().min(8).max(32),
    legal_name: z.string().min(5).max(128),
    trade_name: z.string().min(5).max(128),
    shipping_address: z.string().min(5).max(64),

};

const createSchema = z.object({...base, user_id: z.number().min(1)})


const updateSchema = z.object({
    id: z.number().min(1),
    ...base
})

const updateDtoSchema = z.object(base) 
const createDtoSchema = z.object({
    ...base,
    user_id: z.number().min(1)
}) 

export { createSchema, updateDtoSchema, updateSchema, createDtoSchema }