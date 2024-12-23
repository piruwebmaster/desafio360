import z from 'zod'

const base ={
    name: z.string().min(1).max(64),
    brand: z.string().min(1).max(64),
    code: z.string().min(1).max(64),
    photo: z.string().nullish().default(null),
    
};
const createProductSchema = z.object({...base})

const updateProduct = z.object({
    id: z.number().min(1),
    ...base
})


export { createProductSchema, updateProduct }