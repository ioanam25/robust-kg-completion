#!/bin/bash
dataset="FB15K_237_SPARSE"
teacher_lambda="0.0"
LOSSES="approxNDCG bce binary_listNet lambdaLoss listMLE listNet neuralNDCG pointwise rankNet" #todo: make sure we understand ordinal, see if can be added
#python gen_triplet_dataset.py --model PretrainedBertResNet --dataset ${dataset} --model_dir saved_models/${dataset}/PretrainedBertResNet --topk 10

cd reranking
for LOSS in ${LOSSES}
do
  python triplet_train.py --clip 1 --batch_size 128 --weight_decay 0.01 --lr 0.00003 --dataset ${dataset} --model TripletTextBert --teacher_lambda ${teacher_lambda} --num_epochs 10 --teacher_folder ../saved_models/${dataset}/PretrainedBertResNet --topk 10 --temperature 1 --dropout 0.3 --loss ${LOSS}
  python triplet_evaluation.py --model TripletTextBert --dataset ${dataset} --teacher_lambda ${teacher_lambda} --action eval_mix --split valid
  python triplet_evaluation.py --model TripletTextBert --dataset ${dataset} --teacher_lambda ${teacher_lambda} --action eval_mix --split test
done