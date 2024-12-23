import { disableEntityById, getEntityBydId, getEntities, insertEntity, updateEntity } from "./repository"
import { CreateCategory, UpdateCategory } from "./types"
import { Pagination } from "../utils/schemas/pagination"

export const list = async ( query : Pagination) => {
    const r = await getEntities(query)
    return r
}

export const findById = async (id: number) => {
    return await getEntityBydId(id)
}

export const add = async (product: CreateCategory) =>  {
    return insertEntity(product)
}

export const removeById = async (_id: number)  =>  {
    return await disableEntityById(_id);
}

export const update = async (product: UpdateCategory)  =>  {
    return await updateEntity(product);
}
