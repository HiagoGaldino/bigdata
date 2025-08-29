-- ========================================
-- CRIAÇÃO DO KEYSPACE
-- ========================================
CREATE KEYSPACE IF NOT EXISTS universidade
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

USE universidade;

-- ========================================
-- CRIAÇÃO DAS TABELAS
-- ========================================
-- Tabela 1: Alunos
CREATE TABLE IF NOT EXISTS alunos (
    id UUID PRIMARY KEY,
    nome TEXT,
    idade INT,
    contatos TUPLE<TEXT, TEXT>,           -- (email, telefone)
    cursos LIST<TEXT>,                    -- lista de cursos matriculados
    interesses SET<TEXT>,                 -- conjunto de interesses
    notas MAP<TEXT, FLOAT>                -- disciplina -> nota
);

-- Tabela 2: Professores
CREATE TABLE IF NOT EXISTS professores (
    id UUID PRIMARY KEY,
    nome TEXT,
    departamento TEXT,
    especialidades LIST<TEXT>,
    telefones SET<TEXT>,
    salarios MAP<TEXT, DECIMAL>,          -- ano -> salário
    endereco TUPLE<TEXT, TEXT, INT>       -- (rua, cidade, número)
);

-- ========================================
-- INSERINDO 5 REGISTROS EM CADA TABELA
-- ========================================
INSERT INTO alunos (id, nome, idade, contatos, cursos, interesses, notas)
VALUES (uuid(), 'João', 20, ('joao@email.com','9999-1111'), ['BD','SO'], {'Futebol','Música'}, {'BD':8.5,'SO':7.9});

INSERT INTO alunos (id, nome, idade, contatos, cursos, interesses, notas)
VALUES (uuid(), 'Maria', 22, ('maria@email.com','9999-2222'), ['POO','IA'], {'Leitura','Arte'}, {'POO':9.2,'IA':8.7});

INSERT INTO alunos (id, nome, idade, contatos, cursos, interesses, notas)
VALUES (uuid(), 'Carlos', 21, ('carlos@email.com','9999-3333'), ['Redes','Segurança'], {'Esportes'}, {'Redes':7.5,'Segurança':8.0});

INSERT INTO alunos (id, nome, idade, contatos, cursos, interesses, notas)
VALUES (uuid(), 'Ana', 19, ('ana@email.com','9999-4444'), ['Engenharia','Cálculo'], {'Viagens','Música'}, {'Engenharia':9.0,'Cálculo':8.5});

INSERT INTO alunos (id, nome, idade, contatos, cursos, interesses, notas)
VALUES (uuid(), 'Pedro', 23, ('pedro@email.com','9999-5555'), ['IA','Redes'], {'Cinema'}, {'IA':7.8,'Redes':7.0});

-- Professores
INSERT INTO professores (id, nome, departamento, especialidades, telefones, salarios, endereco)
VALUES (uuid(), 'Dr. Silva', 'Computação', ['IA','Redes'], {'8888-1111','8888-2222'}, {'2023':7500.50}, ('Av Brasil','João Pessoa',100));

INSERT INTO professores (id, nome, departamento, especialidades, telefones, salarios, endereco)
VALUES (uuid(), 'Dr. Souza', 'Matemática', ['Álgebra','Cálculo'], {'8888-3333'}, {'2022':7000.00,'2023':7200.00}, ('Rua Central','Campina Grande',200));

INSERT INTO professores (id, nome, departamento, especialidades, telefones, salarios, endereco)
VALUES (uuid(), 'Dr. Lima', 'Física', ['Quântica'], {'8888-4444'}, {'2023':6800.00}, ('Rua das Flores','Natal',150));

INSERT INTO professores (id, nome, departamento, especialidades, telefones, salarios, endereco)
VALUES (uuid(), 'Dra. Costa', 'Computação', ['Banco de Dados'], {'8888-5555','8888-6666'}, {'2021':6500.00,'2023':7000.00}, ('Av Epitácio','João Pessoa',300));

INSERT INTO professores (id, nome, departamento, especialidades, telefones, salarios, endereco)
VALUES (uuid(), 'Dr. Gomes', 'História', ['Antiga','Moderna'], {'8888-7777'}, {'2023':5000.00}, ('Rua Antiga','Olinda',50));

-- ========================================
-- UPDATES (3)
-- ========================================
UPDATE alunos SET idade = 24 WHERE id = (SELECT id FROM alunos LIMIT 1);
UPDATE professores SET departamento = 'Engenharia' WHERE id = (SELECT id FROM professores LIMIT 1);
UPDATE professores SET salarios = salarios + {'2024':8000.00} WHERE id = (SELECT id FROM professores LIMIT 1);

-- ========================================
-- OPERAÇÕES EM COLEÇÕES
-- (substituição, adição, remoção em lista, set, map)
-- ========================================

-- LIST (cursos / especialidades)
UPDATE alunos SET cursos = ['POO','IA','BD'] WHERE nome = 'Maria';         -- substituição
UPDATE alunos SET cursos = cursos + ['Segurança'] WHERE nome = 'Maria';    -- adição
UPDATE alunos SET cursos = cursos - ['IA'] WHERE nome = 'Maria';           -- remoção

-- SET (interesses / telefones)
UPDATE alunos SET interesses = interesses + {'Teatro'} WHERE nome = 'Ana'; -- adição
UPDATE alunos SET interesses = interesses - {'Música'} WHERE nome = 'Ana'; -- remoção
UPDATE professores SET telefones = {'9999-0000'} WHERE nome = 'Dr. Lima';  -- substituição

-- MAP (notas / salários)
UPDATE alunos SET notas = notas + {'POO':9.5} WHERE nome = 'Carlos';       -- adição/substituição
UPDATE alunos SET notas = notas - {'Redes'} WHERE nome = 'Carlos';         -- remoção
UPDATE professores SET salarios = salarios + {'2025':8500.00} WHERE nome = 'Dr. Silva'; -- adição

-- ========================================
-- SELECTS
-- ========================================
SELECT nome, cursos, notas FROM alunos;

SELECT nome, departamento, especialidades
FROM professores
WHERE departamento = 'Computação' ALLOW FILTERING;

SELECT nome, idade FROM alunos WHERE idade > 20 ORDER BY idade DESC;

-- ========================================
-- CRIANDO UM ÍNDICE SECUNDÁRIO
-- ========================================
CREATE INDEX ON alunos (nome);
CREATE INDEX ON professores (departamento);
