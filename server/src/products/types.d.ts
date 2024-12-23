import { createProductSchema, updateProduct } from "./schemas/createProductSchema"

export type Product = {
    id: number
    name: string
    brand: string
    code: string
    photo: string
    
    state_id: string
    created_by: string
    created_at: Date
}

export type ProductReadDto = {
    id: number
    name: string
    brand: string
    code: string
    photo: string
}

export type ProblemDetails = {
    type?: string
    title?: string
    detail?: string | undefined
    validations?: DetailObject[] | DetailObject
}

export type DetailObject = {
    [key: string]: object
}

type CreateProduct = z.infer<typeof createProductSchema>
type UpdateProduct = z.infer<typeof updateProduct>
