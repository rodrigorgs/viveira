Feature: Filtrar observações

  Background:
    Given o app está rodando
    And as seguintes pessoas existem:
      | 'id' | 'nome'     | 'cpf' |
      | '1'  | 'Fulano'   | '123' |
      | '2'  | 'Sicrano'  | '456' |
      | '3'  | 'Beltrano' | '789' |
    And as seguintes observações existem:
      | 'descricao'               | 'categoria' | 'timestamp'  | 'envolvidos'  | 'autor' |
      | 'Oficina de cupcake'      | 'x'         | '2020-01-03' | {'1'}         | '3'     |
      | 'Oficina de argila'       | 'x'         | '2020-01-01' | {'1','2'}     | '3'     |
      | 'Oficina de compostagem'  | 'x'         | '2020-01-02' | {'1','2','3'} | '3'     |

  Scenario: (eqE) Filtrar por descrição
    Given eu visualizo as observações
    When eu filtro por
      | 'Descrição' |
      | 'argila'   |
    Then a lista possui tamanho {1}
    And eu vejo {'Oficina de argila'} na posição {1} da lista

