import { disableEntityById, getEntityBydId, getEntities, insertEntity, updateEntity } from "@products/repository"
import { CreateProduct, UpdateProduct } from "./types"
import { Pagination } from "../utils/schemas/pagination"

export const list = async ( query : Pagination) => {
    const r = await getEntities(query)
    return r
}

export const findById = async (id: number) => {
    return await getEntityBydId(id)
}

export const add = async (product: CreateProduct) =>  {
    return insertEntity(product)
}

export const removeById = async (_id: number)  =>  {
    return await disableEntityById(_id);
}

export const update = async (product: UpdateProduct)  =>  {
    return await updateEntity(product);
}
