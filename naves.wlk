class Nave{
	var property velocidad = 0
	method propulsar() {
	  self.aumentarVelocidad(20000)
	}

	method aumentarVelocidad(cantidad) {
	  velocidad = (velocidad+cantidad).min(300000)
	}
	

	method preparar(){
		self.aumentarVelocidad(15000)
	}

	method recibirAmenaza()	//abstract method

	method encuentroEnemigo(){ // template method
		self.recibirAmenaza()
		self.propulsar()
	}

}

class NaveDeCarga inherits Nave{

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	method recibirAmenaza() {
		carga = 0
	}

}

class NaveDePasajeros inherits Nave{

	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits Nave{
	
	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method preparar(){
		super()
		modo.preparar(self)
	}

}

class NaveResiduosRadiactivos inherits NaveDeCarga {
	var property estaSellado = false

	method sellarAlVacio(){
		estaSellado  = true
	}

	override method recibirAmenaza(){
		self.sellarAlVacio()		// si se le pone super ejecuta el resivir amenaza de NaveDeCarga
		velocidad = 0
	}

	override method preparar(){
		super()
		self.sellarAlVacio()
	}
}

object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method preparar(nave){
		nave.modo(ataque)
		nave.emitarMensaje("Saliendo en mision")
	}

}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}

	
	method preparar(nave){
		nave.emitirMensaje("Volviendo a la base")
	}

}
