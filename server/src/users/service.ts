import { disableEntityById, getEntityBydId, getEntities, insertEntity, updateEntity } from "./repository"
import { CreateEntity, UpdateEntity } from "./types"
import { Pagination } from "../utils/schemas/pagination"
import { hash } from "@utils/security/hasher"

export const list = async ( query : Pagination) => {
    const r = await getEntities(query)
    return r
}

export const findById = async (id: number) => {
    return await getEntityBydId(id)
}

export const add = async (enitity: CreateEntity, userId: number) =>  {
    enitity.password = await hash({content: enitity.password})
    return insertEntity(enitity, userId)
}

export const removeById = async (_id: number)  =>  {
    return await disableEntityById(_id);
}

export const update = async (enitity: UpdateEntity)  =>  {
    return await updateEntity(enitity);
}
