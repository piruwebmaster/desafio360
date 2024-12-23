import express from 'express'
import { update } from '../service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { updateDtoSchema } from '../schemas';

const router = express.Router();

router.put('/:id', bodyValidatorMiddlware(updateDtoSchema), async (req, res)=>{
    const id = +req.params.id
    const body = {...req.body, delivery_date: req.body.delivery_date ?? null  }
    
    const data = await update({...body, id}, req.user?.id??0)
    res.json(data)
})

export default router;