Feature: Visualizar observação
  Como educador
  Eu quero visualizar observações registradas sobre os estudantes
  Para que eu possa avaliar o seu desempenho

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

  Scenario: A lista de observações mostra descrição e data
    When eu visualizo as observações
    Then eu vejo o texto {'Oficina de cupcake'}
    And eu vejo o texto {'2020-01-03'}

  Scenario: As observações são ordenadas por data (mais recentes primeiro)
    When eu visualizo as observações
    Then eu vejo {'Oficina de cupcake'} na posição {1} da lista
    And eu vejo {'Oficina de compostagem'} na posição {2} da lista
    And eu vejo {'Oficina de argila'} na posição {3} da lista
