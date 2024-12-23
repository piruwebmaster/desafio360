import express from 'express'
import { login } from '../service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { loginDtoSchema } from '../schemas';

const router = express.Router();

router.post('/', bodyValidatorMiddlware(loginDtoSchema), async (req, res)=>{
    console.log(req.body)
    
    const data = await login(req.body)
    if(!data) res.status(401).send()
    else res.json(data)
})

export default router;