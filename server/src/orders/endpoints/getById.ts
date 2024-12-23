import express from 'express'
import { getEntityBydId } from '../repository';

const router = express.Router();

router.get('/:id', async (req, res)=>{
    const id = +req.params.id
    const product = await getEntityBydId(id)
    res.json(product)
})


export default router;
