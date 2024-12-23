import express from 'express'
import { update } from '../service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { updateDtoSchema } from '../schemas';

const router = express.Router();

router.put('/:id', bodyValidatorMiddlware(updateDtoSchema), async (req, res)=>{
    const id = +req.params.id
    const body = req.body
    
    const data = await update({...body, id})
    res.json(data)
})

export default router;