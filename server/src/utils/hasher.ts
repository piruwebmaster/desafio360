import bcrypt from 'bcrypt'


export const hash = ({content}:{content: string})=>{
    return bcrypt.hash(content,12)
}

