import z from 'zod'

const base = {
    email: z.string().min(2).max(256).refine(e=>e.includes('@'), "invalid email address"),
    phone_number: z.string().min(8).max(32),
    date_of_birth: z.coerce.date(),
};

const baseCreate = {
    password: z.string().min(8).max(64),
    role_id: z.number().min(1),
    ...base
}

const createDtoSchema = z.object(baseCreate)

const createSchema = z.object({
    ...baseCreate
})


const updateSchema = z.object({
    id: z.number().min(1),
    ...base
}) 

const updateDtoSchema = z.object(base) 
    

export { createSchema, updateDtoSchema, updateSchema, createDtoSchema }