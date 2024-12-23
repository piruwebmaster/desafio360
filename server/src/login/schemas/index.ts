import z from 'zod'

const loginDtoSchema = z.object({
    email: z.string().min(2).max(256).refine(e=>e.includes('@'), "invalid email address"),
    password: z.string().min(8).max(64)
})

const loginSchema = z.object({
    id: z.number().min(1),
    email: z.string().min(2).max(256).refine(e=>e.includes('@'), "invalid email address"),
    password: z.string().min(8).max(64)
})



export { loginDtoSchema, loginSchema }