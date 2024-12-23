import bcrypt from 'bcrypt'


export const hash = ({content}:{content: string})=>{
    return bcrypt.hash(content,12)
}

export const compare = ({content, encrypted}:{content: string, encrypted: string})=>{
    return bcrypt.compare(content, encrypted)
}

