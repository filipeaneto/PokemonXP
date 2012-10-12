--[[
   naivebayes.lua
   This file is part of PokémonXP

   Copyright (C) 2012 - Filipe Neto

   PokémonXP is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   PokémonXP is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with PokémonXP. If not, see <http://www.gnu.org/licenses/>.
]]

--[[
    Implementa uma inteligência artificial baseada em Naive Bayes para os
    pokémon do jogador, ou seja, as ações involuntárias são escolhidas baseadas
    nas ações voluntárias previamente executadas.
    
    Atributos analisados para a decisão:
    {"LVL: >|<|=", "P.HP: R|Y|G", "E.HP: R|Y|G", "E. Best status", "P.Status: Non volatile All?", 
    "E.Status: All", "E.Type1: All", "E.Type2: All", "Last Movement", "Weather", "Day/Night" }
     
    { 3, 3, 3, 7, 5, 5, 17, 18, 4, 7, 2}
]]

require("table")

NaiveBayesClassifier = {}

setmetatable(NaiveBayesClassifier, {
    __call = function(table, inputSize, nAtts, maxTSsize)
        obj = {
            trainingSet = {},
            inputSize   = inputSize + 1,
            maxTSsize   = maxTSsize or 200,
            classes     = {},
            nAtts       = nAtts or {} -- numero de opcoes para determinado atributo
        }

        setmetatable(obj, { __index = NaiveBayesClassifier })

        return obj
    end
})

function NaiveBayesClassifier:insertClass(class)
    if self.classes[class] then
        return false
    end

    self.classes[class] = 0
    return true
end

function NaiveBayesClassifier:removeClass(class)
    if self.classes[class] then
        self.classes[class] = nil

        for i, v in ipairs(self.trainingSet) do
            if v[1] == class then
                self.trainingSet[i] = nil
            end
        end

        return true
    end

    return false
end

function NaiveBayesClassifier:insertData(data)
    if #data ~= self.inputSize or self.classes[data[1]] == nil then
        return false
    end

    table.insert(self.trainingSet, data)
    self.classes[data[1]] = self.classes[data[1]] + 1

    if #self.trainingSet > self.maxTSsize then
        table.remove(self.trainingSet, 1)
    end

    return true;
end

function NaiveBayesClassifier:clearTrainingSet()
    self.trainingSet = {}
end

function NaiveBayesClassifier:classify(data, m)
    m = m or 1

    print("\n*******\nComeçou a classificação!\n")

    if #data ~= self.inputSize - 1 or #self.trainingSet == 0 then
        return nil
    end

    print("Atendeu os requisitos.")
    print("data size: "..#data)
    print("trainingSet size: "..#self.trainingSet)

    local p = {}
    --[[
        Constrói uma tabela de probabilidade do tipo
        className1 = { P(C1|A*), P(C1), P(A1|C1), P(A2|C2), ...},
        className2 = { P(C2|A*), P(C2), P(A1|C2), P(A2|C2), ...},
                        { ... }
    ]]

    for class, n in pairs(self.classes) do
        print("Calculando para a classe "..class)

        if n == 0 then
            print("Certeza que nao e essa classe "..class)
            p[class] = { 0 }
            break
        end

        p[class] = { 1, n / #self.trainingSet }
        print("P("..class..") = "..p[class][2])

        for i, att in ipairs(data) do
            local count = 0

            for j, line in ipairs(self.trainingSet) do
                if line[i+1] == att and line[1] == class then
                    count = count + 1
                end
            end
            
            local nc = self.classes[class]          -- elementos da classe
            local pp = 1 / (self.nAtts[i] or 2)     -- probilidade a priori
            local na = count                        -- destes quantos sao att
            
            print("P("..att.."|"..class..") = "..((na + m*pp)/(nc + m)))

            table.insert(p[class], (na + m*pp)/(nc + m))
        end

        for i, v in ipairs(p[class]) do
            p[class][1] = p[class][1] * v
        end

        print("P("..class.."|".."A*) = "..p[class][1])
    end

    local maxP, maxClass = -1, nil

    for class, P in pairs(p) do
        if P[1] > maxP then maxP, maxClass = P[1], class end
    end

    return maxClass
end

