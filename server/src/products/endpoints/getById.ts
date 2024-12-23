import express from 'express'
import { findById } from '@products/service';

const router = express.Router();

router.get('/:id', async (req, res)=>{
    const id = +req.params.id
    const product = await findById(id)
    res.json(product)
})


export default router;
