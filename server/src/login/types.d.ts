import { loginSchema, loginDtoSchema } from "./schemas";
import z from 'zod'

export type Login = z.infer<typeof loginSchema>
export type LoginDto = z.infer<typeof loginDtoSchema>