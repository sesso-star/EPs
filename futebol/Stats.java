package futebol;

public class Stats {
	private int idade;
	private double altura;
	private double peso;
	private int velocidade;
	private int explosao;
	private int resistencia;

	public Stats(int idade, double altura, double peso, int velocidade, int explosao, int resistencia) {
		if (idade < 0) {
			throw new IllegalArgumentException("idade deve ser maior do que zero");
		}
		if (altura < 0) {
			throw new IllegalArgumentException("altura deve ser maior do que zero");
		}
		if (peso < 0) {
			throw new IllegalArgumentException("peso deve ser maior do que zero");
		}
		if (velocidade > 5 || velocidade < 0) {
			throw new IllegalArgumentException("velocidade deve ser um inteiro no intervalo [0, 5]")
		}
		if (explosao > 5 || explosao < 0) {
			throw new IllegalArgumentException("explosao deve ser um inteiro no intervalo [0, 5]")
		}
		if (resistencia > 5 || resistencia < 0) {
			throw new IllegalArgumentException("resistencia deve ser um inteiro no intervalo [0, 5]")
		}

		this.idade = idade;
		this.altura = altura;
		this.peso = peso;
		this.velocidade = velocidade;
		this.explosao = explosao;
		this.resistencia = resistencia;
	}

	public getIdade() {
		return idade;
	}

	public getAltura() {
		return altura;
	}

	public getPeso() {
		return peso;
	}

	public getVelocidade() {
		return velocidade;
	}

	public getExplosao() {
		return explosao;
	}

	public getResistencia() {
		return resistencia;
	}
}

