import { createCategorychema, updateCategorySchema } from "./schemas"
import { z } from 'zod'


type CreateCategory = z.infer<typeof createCategorychema>
type UpdateCategory = z.infer<typeof updateCategorySchema>


export type Category = {
    state_id: string
} & UpdateCategory
