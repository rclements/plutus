module Plutus
  # The Expense class is an account type used to represents assets or services consumed in the generation of revenue.
  #
  # === Normal Balance
  # The normal balance on Expense accounts is a *Debit*.
  #
  # @see http://en.wikipedia.org/wiki/Expense Expenses
  #
  # @author Michael Bulat
  class Expense < Account

    # The credit balance for the account.
    #
    # @example
    #   >> expense.credits_balance
    #   => #<BigDecimal:103259bb8,'0.1E4',4(12)>
    #
    # @return [BigDecimal] The decimal value credit balance
    def credits_balance
      credits_balance = BigDecimal.new('0')
      credit_transactions.each do |credit_transaction|
        credits_balance = credits_balance + credit_transaction.amount
      end
      return credits_balance
    end

    # The debit balance for the account.
    #
    # @example
    #   >> expense.debits_balance
    #   => #<BigDecimal:103259bb8,'0.3E4',4(12)>
    #
    # @return [BigDecimal] The decimal value credit balance
    def debits_balance
      debits_balance = BigDecimal.new('0')
      debit_transactions.each do |debit_transaction|
        debits_balance = debits_balance + debit_transaction.amount
      end
      return debits_balance
    end

    # The balance of the account.
    #
    # Expenses have normal debit balances, so the credits are subtracted from the debits
    # unless this is a contra account, in which debits are subtracted from credits
    #
    # @example
    #   >> expense.balance
    #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
    #
    # @return [BigDecimal] The decimal value balance
    def balance
      unless contra
        debits_balance - credits_balance
      else
        credits_balance - debits_balance
      end
    end

    # This class method is used to return
    # the balance of all Expense accounts.
    #
    # Contra accounts are automatically subtracted from the balance.
    #
    # @example
    #   >> Expense.balance
    #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
    #
    # @return [BigDecimal] The decimal value balance
    def self.balance
      accounts_balance = BigDecimal.new('0')
      accounts = self.find(:all)
      accounts.each do |expense|
        unless expense.contra
          accounts_balance += expense.balance
        else
          accounts_balance -= expense.balance
        end
      end
      accounts_balance
    end
  end
end
