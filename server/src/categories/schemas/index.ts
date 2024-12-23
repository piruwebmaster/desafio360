import z from 'zod'

const base = {
    name: z.string().min(1).max(32),   
};

const createCategorychema = z.object(base)

const updateCategorySchema = z.object({
    id: z.number().min(1),
    ...base
}) 
    

export { createCategorychema, updateCategorySchema }