package futebol;

class Forca {

    private CalculaForcaStrategy strategy;
    private int forca;

    public Forca(CalculaForcaStrategy strategy) {
        this.strategy = strategy;
    }

    private void calcForca(Stats stats) {
        this.forca = this.strategy.calc(stats);
        return this.forca;
    }
}