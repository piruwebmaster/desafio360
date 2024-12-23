import { db } from '../utils/persistence/database';
import { CreateProduct, Product, UpdateProduct } from '@products/types';
import { Pagination } from '../utils/schemas/pagination';

export const  getEntities = async ({ page, limit }: Pagination) =>{
    const { query } = db();
    const r = await query<Product>({
      query: "select * from sales.VW_PRODUCTS ORDER by id offset ((:page - 1) * :limit) rows fetch next :limit rows only",
      replacement: {
        page: page,
        limit: limit
      }
    })
    
    return r
}

export const getEntityBydId = async (id: number) =>{
    const { query } = db();
    const result = await query<Product>({ query: "select * from sales.VW_PRODUCTS where id = :id",  replacement: { id} } )
    return result[0]
}

export const disableEntityById = async (id: number) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.life_cicle_product :id, 'ELIMINADO'", replacement:  {id} });
  
}

export const insertEntity = async (product: CreateProduct,  userId: number) =>{
  const { insertProcedure } = db();
  const id  = await insertProcedure({query: "exec SALES.insert_product :name, :brand, :code, :photo,  :userId", replacement:  {...product, userId} });
  return id
  
}

export const updateEntity = async (product: UpdateProduct) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.update_product :id, :name, :brand, :code, :photo  ", replacement: product   });
  
}