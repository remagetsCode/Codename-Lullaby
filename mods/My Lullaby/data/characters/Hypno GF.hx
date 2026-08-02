var maybeShesHypno = false;
var shesHypno = false;

function update() {
    if(healthHypno < 1 && healthHypno > 0.3 && (shesHypno || !maybeShesHypno)){
		shesHypno = false;
		maybeShesHypno = true;
		animation.addByPrefix("idle", "gf_idle_ok_maybe_shes_hypno_2s", 24, false);
		playAnim("idle");
	}
	else if(healthHypno <= 0.3 && !shesHypno && maybeShesHypno){
		shesHypno = true;
		maybeShesHypno = false;
		animation.addByPrefix("idle", "gf_idle_ok_shes_hypno_2s instance 1", 24, false);
		playAnim("idle");
	}
	else if(healthHypno >= 1 && (shesHypno || maybeShesHypno)){
		shesHypno = false;
		maybeShesHypno = false;
		animation.addByPrefix("idle", "gf_idle_not_hypno_2s", 24, false);
		playAnim("idle");
	}
}