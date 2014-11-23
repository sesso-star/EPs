package futebol;

public class Forca {

    private CalculaForcaStrategy strategy;
    private double forca;

    public Forca(CalculaForcaStrategy strategy) {
        this.strategy = strategy;
    }

    private double calcForca(Stats stats) {
        this.forca = this.strategy.calc(stats);
        return this.forca;
    }
}