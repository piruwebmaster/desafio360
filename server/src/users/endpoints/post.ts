import express from 'express'
import { add } from '../service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { createDtoSchema } from '../schemas';

const router = express.Router();

router.post('/', bodyValidatorMiddlware(createDtoSchema), async (req, res)=>{
    console.log(req.body)
    
    const data = await add({...req.body}, req.user?.id??0)
    res.json(data)
})

export default router;