import express from 'express'
import { removeById } from '../service';


const router = express.Router();

router.delete('/:id', async (req, res)=>{
    const id = +req.params.id
    const response =  await removeById(id)
    res.json(response);
})


export default router;