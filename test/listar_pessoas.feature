Feature: Listar pessoas

  Background:
    Given o app está rodando
    And as seguintes pessoas existem:
      | 'id' | 'nome'     | 'cpf' |
      | '1'  | 'Fulano'   | '123' |
      | '2'  | 'Sicrano'  | '456' |
      | '3'  | 'Beltrano' | '789' |

  Scenario: As pessoas estão ordenadas por nome
    When eu visualizo as pessoas
    Then eu vejo {'Beltrano'} na posição {1} da lista
    And eu vejo {'Fulano'} na posição {2} da lista
    And eu vejo {'Sicrano'} na posição {3} da lista
