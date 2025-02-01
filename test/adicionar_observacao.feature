Feature: Adicionar observacao

  Background:
    Given o app está rodando
    And as seguintes pessoas existem:
      | 'id' | 'nome'     | 'cpf' |
      | '1'  | 'Fulano'   | '123' |
      | '2'  | 'Sicrano'  | '456' |
      | '3'  | 'Beltrano' | '789' |

  Scenario: Adicionar observação com data futura
    Given hoje é {'2020-01-01'}
    When eu adiciono uma observação com
      | 'Descrição' | 'Categoria' | 'Data/hora'  |
      | 'Oficina'   | 'x'         | '2020-01-02' |
    Then eu vejo o texto {'Data inválida'}

  Scenario: Adicionar observação com data passada
    Given hoje é {'2020-01-01'}
    When eu adiciono uma observação com
      | 'Descrição' | 'Categoria' | 'Data/hora'  |
      | 'Oficina'   | 'x'         | '2019-12-31' |
    Then eu não vejo o texto {'Data inválida'}