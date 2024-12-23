import { BindOrReplacements, QueryTypes, Sequelize } from 'sequelize';

const db = ()=>{
    const sequelize =  new Sequelize(
        process.env.DB_DBNAME??"",
        process.env.DB_USERNAME??"",
        process.env.DB_PASSWORD??"", {
        dialect: 'mssql',
        host: process.env.DB_HOST??""
    })

    const queryMethod = async <T>({ query, replacement}: {query: string, replacement: BindOrReplacements | undefined})=>{
        const result = await sequelize.query(query, {
            type: QueryTypes.SELECT,
            replacements: replacement
              })
        return result as T[]
    }

    const procedureMethod = async <T>({ query, replacement}: {query: string, replacement: BindOrReplacements | undefined})=>{
        try {

            await sequelize.query(query, {
                type: QueryTypes.RAW,
                replacements: replacement
            }) as T
            return { success: true, errorMsg: ""}
        }catch(ex){
            console.log(ex);
            return { success: false, errorMsg: ex instanceof Object && 'message' in ex && typeof ex.message === 'string'? ex.message: "Error no definido"}
        }
    }

    const insertProcedure = async ({ query, replacement}: {query: string, replacement: BindOrReplacements | undefined})=>{
        try {

            const [result ] = await sequelize.query<{id: number}>(query, {
                type: QueryTypes.SELECT,
                replacements: replacement
            })
            
            return { id: result.id}
        }catch(ex){
            console.log(ex);
            return { success: false, errorMsg: ex instanceof Object && 'message' in ex && typeof ex.message === 'string'? ex.message: "Error no definido"}
        }
    }
    return { query: queryMethod , sequelize, procedure: procedureMethod, insertProcedure };
}

export { db }






