import { createSchema, updateSchema } from "./schemas/index"
import z from 'zod'


type CreateEntity = z.infer<typeof createSchema>
type UpdateEntity = z.infer<typeof updateSchema>

export type Entity = {
    state_id: string
} & UpdateEntity
